{ config, pkgs, lib, inputs, ... }:

let
  # Windows bare metal identifier by-id
  windowsDisk = "/dev/disk/by-id/ata-PNY_CS900_500GB_SSD_PNY21232106070100CA6";
in
{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";        # don't auto-start guests
    onShutdown = "shutdown";  # graceful ACPI on host poweroff
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;      # run guests as qemu-libvirtd
      swtpm.enable = true;    # TPM 2.0
    };
  };

  programs.virt-manager.enable = true;

  # libvirtd: manage VMs
  users.users.leo.extraGroups = [ "libvirtd" "kvm" "disk" ];

  users.users.qemu-libvirtd.extraGroups = [ "disk" ];

  # --- Declarative VM definition (NixVirt) -------------------------------

  virtualisation.libvirt = {
    enable = true;
    swtpm.enable = true;

    connections."qemu:///system" = {
      networks = [{
        definition = pkgs.writeText "default-network.xml" ''
          <network>
            <name>default</name>
            <uuid>f6dda36a-d309-4e4f-bec8-c8dfe71fb294</uuid>
            <forward mode="nat"/>
            <bridge name="virbr0" stp="on" delay="0"/>
            <ip address="192.168.122.1" netmask="255.255.255.0">
              <dhcp>
                <range start="192.168.122.2" end="192.168.122.254"/>
                <host mac="52:54:00:ab:cd:01" name="windows" ip="192.168.122.10"/>
              </dhcp>
            </ip>
          </network>
        '';
        active = true;
      }];

      domains = [{
        active = false; # autostart
        definition = pkgs.writeText "windows.xml" ''
          <domain type="kvm">
            <name>windows</name>
            <uuid>90f80dae-2231-4da2-b08c-a36dad98b02b</uuid>
            <memory unit="GiB">16</memory>
            <vcpu placement="static">8</vcpu>
            <cputune>
              <vcpupin vcpu="0" cpuset="8"/>
              <vcpupin vcpu="1" cpuset="20"/>
              <vcpupin vcpu="2" cpuset="9"/>
              <vcpupin vcpu="3" cpuset="21"/>
              <vcpupin vcpu="4" cpuset="10"/>
              <vcpupin vcpu="5" cpuset="22"/>
              <vcpupin vcpu="6" cpuset="11"/>
              <vcpupin vcpu="7" cpuset="23"/>
              <emulatorpin cpuset="0-3"/>
            </cputune>
            <os firmware="efi">
              <type arch="x86_64" machine="q35">hvm</type>
              <firmware>
                <feature enabled="no" name="enrolled-keys"/>
                <feature enabled="yes" name="secure-boot"/>
              </firmware>
            </os>
            <features>
              <acpi/>
              <apic/>
              <hyperv mode="custom">
                <relaxed state="on"/>
                <vapic state="on"/>
                <spinlocks state="on" retries="8191"/>
                <vpindex state="on"/>
                <synic state="on"/>
                <stimer state="on"/>
              </hyperv>
              <vmport state="off"/>
              <smm state="on"/>
            </features>
            <cpu mode="host-passthrough" check="none" migratable="on">
              <topology sockets="1" dies="1" cores="4" threads="2"/>
            </cpu>
            <clock offset="localtime">
              <timer name="rtc" tickpolicy="catchup"/>
              <timer name="pit" tickpolicy="delay"/>
              <timer name="hpet" present="no"/>
              <timer name="hypervclock" present="yes"/>
            </clock>
            <on_poweroff>destroy</on_poweroff>
            <on_reboot>restart</on_reboot>
            <on_crash>destroy</on_crash>
            <pm>
              <suspend-to-mem enabled="no"/>
              <suspend-to-disk enabled="no"/>
            </pm>
            <devices>
              <emulator>${pkgs.qemu_kvm}/bin/qemu-system-x86_64</emulator>

              <!-- Bare-metal Windows SSD, virtio-blk passthrough. -->
              <disk type="block" device="disk">
                <driver name="qemu" type="raw" cache="none" io="native" discard="unmap"/>
                <source dev="${windowsDisk}"/>
                <target dev="vda" bus="virtio"/>
                <boot order="1"/>
              </disk>

              <controller type="usb" model="qemu-xhci" ports="15"/>
              <controller type="pci" model="pcie-root"/>

              <interface type="network">
                <mac address="52:54:00:ab:cd:01"/>
                <source network="default"/>
                <model type="virtio"/>
              </interface>

              <input type="tablet" bus="usb"/>
              <input type="keyboard" bus="usb"/>

              <graphics type="spice" autoport="yes">
                <listen type="address"/>
                <gl enable="no"/>
              </graphics>
              <video>
                <model type="virtio" heads="1" primary="yes"/>
              </video>
              <sound model="ich9"/>
              <audio id="1" type="spice"/>

              <tpm model="tpm-crb">
                <backend type="emulator" version="2.0"/>
              </tpm>

              <rng model="virtio">
                <backend model="random">/dev/urandom</backend>
              </rng>

              <channel type="unix">
                <target type="virtio" name="org.qemu.guest_agent.0"/>
              </channel>

              <memballoon model="virtio"/>
            </devices>
          </domain>
        '';
      }];
    };
  };
}
