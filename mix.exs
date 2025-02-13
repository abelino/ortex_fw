defmodule OrtexFirmware.MixProject do
  use Mix.Project

  @app :ortex_fw
  @version "0.1.0"
  @all_targets [:rpi4]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.17",
      archives: [nerves_bootstrap: "~> 1.13"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {OrtexFirmware.Application, []}
    ]
  end

  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:nx, "~> 0.9"},
      {:ortex, "~> 0.1"},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.11.0"},
      {:toolshed, "~> 0.4.0"},

      # Dependencies for all targets except :host
      {:nerves_pack, "~> 0.7.1", targets: @all_targets},
      {:nerves_runtime, "~> 0.13.0", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi4, "~> 1.24", runtime: false, targets: :rpi4}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
