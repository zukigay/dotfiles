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
             (guix transformations)
             (gnu services xorg)
             (nongnu packages game-client)
             (nongnu packages nvidia)
             (nongnu services nvidia)
             (nongnu system linux-initrd)
             (nongnu packages linux)
             (guix packages)
             ;; imports that come from jank
             (gnu packages package-management)
             (gnu packages zig-xyz)
             (gnu packages video)
             (gnu packages admin)
             (gnu packages vim)
             (gnu packages terminals)
             (gnu packages version-control)
             )
(use-service-modules cups desktop networking ssh xorg)
;; (use-service-modules networking ssh)
;; (use-service-modules desktop networking)

(define zig-wayland-3
  (package
    (inherit zig-wayland)
    (version "0.3.0")
    )
  )
(define zig-wlroots-0.18.2
  (package
    (inherit zig-wlroots)
    (version "0.18.2")))

(define river-0.3.9
  (package
    (inherit river)
    (version "0.3.9")
    (inputs (modify-inputs (package-inputs river)
                           
                           (replace "zig" (specification->package "zig@0.14.0"))
                           (replace "zig-wlroots" zig-wlroots-0.18.2)
                           (replace "zig-wayland" zig-wayland-3)
                           ))
    ))

;; (define latest-river
;; (options->transformation
;;  '((with-latest . "river")
;;    (inputs (modify-inputs (package-inputs river)
;;                           ;; (delete zig)
;;                           (prepend zig@0.14.0)
;;                           ;; (append zig@0.14.0)
;;                           )))))

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

      (packages 
        (append 
          ;; packages that don't need a nvidia override
          (list steam-nvidia
                      (specification->package "font-google-noto-sans-cjk")
                      (specification->package "font-google-noto-emoji")
                      (specification->package "font-google-noto")
                      ;; xdg portal stuff
                      ;; (specification->package "xdg-desktop-portal")
                      ;; (specification->package "xdg-desktop-portal-gtk")
                      ;; (specification->package "xdg-desktop-portal-wlr")
                      )
          ;; packages that use mesa instead of nvidia
        (map replace-mesa (cons* btop
                                       git ;; doesn't need to be here but whocares
                                       ;; (latest-river river)
                                       river-0.3.9
                                       obs
                                       flatpak
                                       ;; awesome
                                       neovim ;; also doesn't need to have its mesa replaced
                                       kitty
                                       %base-packages))))
                ;; steam-nvidia))

  ;; (packages (append (list (specification->package "awesome")
  ;;                         (specification->package "neovim")
  ;;                         (specification->package "kitty"))
  ;;                   %base-packages))

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
                         (options "subvol=/@guixroot,subvolid=904,compress=zstd:3")
                         (needed-for-boot #t)
                         (type "btrfs")) 
                       ;; shared home between gentoo and guix
                       ;;
                       ;; also this should probably be set to mount after root 
                       ;; but since its fucking ROOT it will be mounted first anyway
                       (file-system
                         (mount-point "/home")
                         (device (uuid
                                   "d1873cb5-ddb1-49c1-ab58-4e9763938acd"
                                   'btrfs))
                         (options "subvol=/@home,subvolid=257,compress=zstd:3")
                         (needed-for-boot #t)
                         (type "btrfs")) 
                       ;; ssd for games and other stuff
                       (file-system
                         (mount-point "/mnt/uberdrive")
                         (device (file-system-label "uberdrive"))
                         (type "ext4")
                         (needed-for-boot #f)
                         )
                       ;; a laptop harddrive taking on a new life
                       (file-system
                         (mount-point "/mnt/ssddrive")
                         (device (file-system-label "exlapdrive"))
                         (type "ext4")
                         (needed-for-boot #f)
                         )
                       ;; extra harddrive used for backups and steam games
                       (file-system
                         (mount-point "/mnt/harddrive")
                         (device (uuid
                                   "08d01f59-dee1-4c01-b1c3-0200d5ec8264"))
                         (type "ext4")
                         (needed-for-boot #f))
                       %base-file-systems)))
