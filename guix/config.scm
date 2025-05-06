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
             (guix build-system cargo)
             (guix git-download)
             (guix licenses)
             ;; imports that come from jank
             (gnu packages wm)
             (gnu packages kde-plasma) ;; importing kde just to use polkit lmao
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

(define zig-wayland-custom
  (package
    (inherit zig-wayland)
    (version "0.3.0")
    )
  )
(define zig-wlroots-custom
  (package
    (inherit zig-wlroots)
    (version "0.18.2")))

(define river-custom
  (package
    (inherit river)
    (version "0.3.9")
    (inputs (modify-inputs (package-inputs river)
                           
                           (replace "zig" (specification->package "zig@0.14.0"))
                           (replace "zig-wlroots" zig-wlroots-custom)
                           (replace "zig-wayland" zig-wayland-custom)
                           ))
    ))
;; (define rust-river-layout-toolkit
;;   (package
;;     (name "rust-river-layout-toolkit")
;;     (version "0.1.7")
;;     (source (origin
;;               (method git-fetch)
;;               ;; (sha256
;;               ;;   (base32 "8001acf"))
;;               (hash "1xbkskgnchrjpa7b083nj1dfvj1nlayg494w710c5rxm0w7sklaf")
;;               ;; (sha256
;;               ;;   (base32 "1xbkskgnchrjpa7b083nj1dfvj1nlayg494w710c5rxm0w7sklaf"))
;;               (uri (git-reference
;;                 (url "https://github.com/MaxVerevkin/river-layout-toolkit")
;;                 ;; (commit "0.1.7")
;;                 ;; (commit (string-append "v" version))
;;                 (commit "8001acf")
;;                 )
;;                 )))
;;     ;; (inputs (list rust-log rust-thiserror rust-wayrs-client))
;;     (build-system cargo-build-system)
;;     (arguments 
;;       `(#:install-source? #t
;;         #:cargo-inputs (("rust-log" ,rust-log-0.4)
;;          ;; ("thiserror",rust-thiserror-2.0)
;;          ;; ("wayrs-client",rust-wayrs-client-1.2)
;;          ;; ("mlua")
;;          ))
;;         )
;;     (license expat)
;;     ;; (license MIT)
;;     (synopsis "a river layout library")
;;     (description "This package simplifies writing a river layout generator in rust.")
;;     (home-page "https://github.com/MaxVerevkin/river-layout-toolkit")
;;   ))

;; (define rust-river-luatile
;;   (package
;;     (name "rust-river-luatile")
;;     (version "0.1.4")
;;     (source (origin
;;               (method url-fetch)
;;               ;; no idea if guix has a nix style github only fetch option
;;               (uri (string-append "https://github.com/MaxVerevkin/river-luatile/archive/refs/tags/v" version ".tar.gz"))
;;               (sha256
;;                 (base32
;;                   "b0751192d484d6a418009eea5f2f84a05574c3ba00a51e0b82254fa3778de80e"))))
;;     ;; (inputs (list rust-log )
;;     (build-system cargo-build-system)
;;     (arguments 
;;       `(#:install-source? #f
;;         #:cargo-inputs
;;         (
;;          ("log",rust-log-0.4)
;;          ("river-layout-toolkit",river-layout-toolkit)
;;           )))
;;     (license gpl3)
;;     (synopsis "a river layout library")
;;     (description "This package simplifies writing a river layout generator in rust.")
;;     (home-page "https://github.com/MaxVerevkin/river-layout-toolkit")
;;
;;     ))



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
                      rust-river-layout-toolkit
                      ;; xdg portal stuff
                      ;; (specification->package "xdg-desktop-portal")
                      ;; (specification->package "xdg-desktop-portal-gtk")
                      ;; (specification->package "xdg-desktop-portal-wlr")
                      )
          ;; packages that use mesa instead of nvidia
        (map replace-mesa (cons* btop
                                       git ;; doesn't need to be here but whocares
                                       ;; (latest-river river)
                                       obs
                                       flatpak

                                       ;; adding wm setup stuff
                                       river-custom
                                       dunst
                                       waybar
                                       wlr-randr
                                       polkit-kde-agent

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
              (service screen-locker-service-type
                (screen-locker-configuration
                  (name "hyprlock")
                  (program (file-append river-custom "/bin/river"))
                  (using-pam? #t)
                  (using-setuid? #f)))
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
                (bootloader grub-efi-bootloader)
                ;; (targets (list "/dev/nvme0n1p1"))
                (targets (list "/efi"))
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
                         (needed-for-boot? #t)
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
                         (needed-for-boot? #t)
                         (type "btrfs")) 
                       ;; genroot
                       (file-system
                         (mount-point "/mnt/genroot")
                         (device (uuid
                                   "d1873cb5-ddb1-49c1-ab58-4e9763938acd"
                                   'btrfs))
                         (options "subvol=/@genroot,subvolid=903,compress=zstd:3")
                         (mount? #f)
                         (type "btrfs")) 
                       ;; ssd for games and other stuff
                       (file-system
                         (mount-point "/mnt/uberdrive")
                         ;; to lazy to use uuid's
                         (device (file-system-label "uberdrive"))
                         (type "ext4")
                         (needed-for-boot? #f)
                         )
                       ;; a laptop harddrive taking on a new life
                       (file-system
                         (mount-point "/mnt/ssddrive")
                         ;; to lazy to use uuid's
                         (device (file-system-label "exlapdrive"))
                         (type "ext4")
                         (needed-for-boot? #f)
                         )
                       ;; extra harddrive used for backups and steam games
                       (file-system
                         (mount-point "/mnt/harddrive")
                         (device (uuid
                                   "08d01f59-dee1-4c01-b1c3-0200d5ec8264"))
                         (type "ext4")
                         (needed-for-boot? #f))
                       %base-file-systems)))
