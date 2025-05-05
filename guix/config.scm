;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
             (gnu services xorg)
             (nongnu packages nvidia)
             (nongnu services nvidia)
             (nongnu system linux-initrd)
             (nongnu packages linux))
(use-service-modules cups desktop networking ssh xorg)
;; (use-service-modules networking ssh)
;; (use-service-modules desktop networking)

(operating-system
  (kernel linux)
  (kernel-arguments '("modprobe.blacklist=nouveau"
                      ;; Set this if the card is not used for displaying or
                      ;; you're using Wayland:
                      "nvidia_drm.modeset=1"))
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "zukiguix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "zuki")
                  (comment "Zuki")
                  (group "users")
                  (home-directory "/home/zuki")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "awesome")
                          (specification->package "neovim")
                          (specification->package "kitty"))
;;                          (specification->package "nss-certs"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services (cons* 
              (service nvidia-service-type)
              (set-xorg-configuration
                (xorg-configuration
                  (modules (cons nvda %default-xorg-modules))
                  (drivers '("nvidia"))))
              ;; (service gnome-desktop-service-type)
                   ;; (service xfce-desktop-service-type)
    (modify-services %desktop-services
             (delete gdm-service-type)
             (guix-service-type config => (guix-configuration
               (inherit config)
               (substitute-urls
                (append (list "https://substitutes.nonguix.org")
                  %default-substitute-urls))
               (authorized-keys
                (append (list (local-file "./signing-key.pub"))
                  %default-authorized-guix-keys)))))
                   ;; %desktop-services)
            ))
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/nvme0n1p1"))
                (keyboard-layout keyboard-layout)))
  ;; (swap-devices (list (swap-space
  ;;                       (target (uuid
                                 ;; "1112-6E28")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "d1873cb5-ddb1-49c1-ab58-4e9763938acd"
                                  'btrfs))
                         (options "subvol=/@guixroot")
                         (type "btrfs")) %base-file-systems)))
