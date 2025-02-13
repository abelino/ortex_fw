import Config

config :ortex, Ortex.Native,
  target: "aarch64-unknown-linux-gnu",
  env: [
    {"CC", ""},
    {"CFLAGS", ""},
    {"CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER", "aarch64-nerves-linux-gnu-gcc"}
  ]

config :logger, backends: [RingLogger]

config :shoehorn, init: [:nerves_runtime, :nerves_pack]

config :nerves, :erlinit, update_clock: true

keys =
  System.user_home!()
  |> Path.join(".ssh/id_{rsa,ecdsa,ed25519}.pub")
  |> Path.wildcard()

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

config :vintage_net,
  regulatory_domain: "00",
  config: [
    {"usb0", %{type: VintageNetDirect}},
    {"eth0",
     %{
       type: VintageNetEthernet,
       ipv4: %{method: :dhcp}
     }},
    {"wlan0", %{type: VintageNetWiFi}}
  ]

config :mdns_lite,
  hosts: [:hostname, "nerves"],
  ttl: 120,
  services: []

# import_config "#{Mix.target()}.exs"
