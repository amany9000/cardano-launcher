{ pkgs ? import ./nix/nivpkgs.nix {} }:

with pkgs;

mkShell {
  buildInputs = [
    # javascript
    nodejs nodePackages.npm
    # documentation tools
    pandoc librsvg gnumake
  ] ++ lib.optional stdenv.isLinux mscgen ++ [
    # util to update nixpkgs pins
    niv.niv
    # jormungandr
    cardanoWalletPackages.jormungandr
    cardanoWalletPackages.cardano-wallet-jormungandr
    # cardano-node
    cardano-node
    cardanoWalletPackages.cardano-wallet-byron
    cardanoWalletPackages.cardano-wallet-shelley
  ];

  # Test data from cardano-wallet repo used in their integration tests.
  TEST_CONFIG_BYRON = cardanoWalletPackages.src + /lib/byron/test/data/cardano-node-byron;
  TEST_CONFIG_SHELLEY = cardanoWalletPackages.src + /lib/shelley/test/data/cardano-node-shelley;

  # Contents of configuration subdirectory of cardano-node repo.
  BYRON_CONFIGS = cardanoWalletPackages.cardano-node.configs;

  # Corresponds to
  # https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest/download/1/index.html
  CARDANO_NODE_CONFIGS = cardanoWalletPackages.cardano-node.deployments;
}
