{ config, pkgs, lib, inputs, ... }:

let
  # Stable identifier for the bare-metal Windows SSD.
  # Resolves to /dev/sdc; survives reboots and SATA port changes.
  windowsDisk = "/dev/disk/by-id/ata-PNY_CS900_500GB_SSD_PNY21232106070100CA6";
in
{
  # --- Host enablement ---------------------------------------------------

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";        # don't auto-start guests
    onShutdown = "shutdown";  # graceful ACPI on host poweroff
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;      # run guests as qemu-libvirtd, safer
      swtpm.enable = true;    # TPM 2.0 for Win11
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];  # secure-boot capable firmware
      };
    };
  };

  programs.virt-manager.enable = true;

  # libvirtd: manage VMs without sudo. kvm: /dev/kvm access.
  # disk: lets the qemu user open the raw block device for the Windows SSD.
  users.users.leo.extraGroups = [ "libvirtd" "kvm" "disk" ];

  # The qemu-libvirtd system user also needs to read/write the raw disk.
  # Add it to the disk group; alternative is a udev rule scoped to this device.
  users.users.qemu-libvirtd.extraGroups = [ "disk" ];

  # Default NAT network ("default") is created by libvirt but not autostarted
  # on NixOS. Easiest path: start it once via virsh, or declare it below.
  # NixVirt handles this for us — see networks block.

  # --- Declarative VM definition (NixVirt) -------------------------------

  virtualisation.libvirt = {
    enable = true;
    swtpm.enable = true;

    connections."qemu:///system" = {
      networks = [{
        definition = inputs.nixvirt.lib.network.writeXML
          inputs.nixvirt.lib.network.defaultNetwork;
        active = true;
      }];

      domains = [{
        # `active = false` means: ensure the domain is *defined* in libvirt,
        # but don't auto-start it. Flip to true (or just run `virsh start windows`).
        active = false;
        definition = pkgs.writeText "windows.xml" ''
          <domain type="kvm">
            <name>windows</name>
            <memory unit="GiB">16</memory>
            <vcpu placement="static">8</vcpu>
            <os firmware="efi">
              <type arch="x86_64" machine="q35">hvm</type>
              <firmware>
                <feature enabled="no" name="enrolled-keys"/>
                <feature enabled="yes" name="secure-boot"/>
              </firmware>
              <boot dev="hd"/>
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

              <!-- Bare-metal Windows SSD passed through as a whole block device.
                   Using bus="sata" for first boot so Windows can find it without
                   virtio drivers. Switch to virtio + virtio-win ISO later for perf. -->
              <disk type="block" device="disk">
                <driver name="qemu" type="raw" cache="none" io="native" discard="unmap"/>
                <source dev="${windowsDisk}"/>
                <target dev="sda" bus="sata"/>
                <boot order="1"/>
              </disk>

              <!-- virtio-win ISO slot, empty. Insert via virt-manager when needed. -->
              <disk type="file" device="cdrom">
                <driver name="qemu" type="raw"/>
                <target dev="sdb" bus="sata"/>
                <readonly/>
              </disk>

              <controller type="usb" model="qemu-xhci" ports="15"/>
              <controller type="pci" model="pcie-root"/>

              <interface type="network">
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
            </devices>
          </domain>
        '';
      }];
    };
  };
}
