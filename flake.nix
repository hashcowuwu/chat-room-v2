{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    # 使用 devShells 定义开发环境
    devShells."${system}".default = pkgs.mkShell {
      # 开发环境中需要的包
      packages = with pkgs; [
        bun # bun v20

        # 你可以在这里添加其他开发需要的工具，例如：
        nodejs
        git
        # ripgrep
      ];

      # (可选) 进入开发环境时执行的命令
      shellHook = ''
        exec fish
         echo "已进入 Node.js 开发环境！"
         echo "bun 版本: $(bun --version)"
         echo "pnpm 版本: $(pnpm --version)"
      '';
    };

    # (可选) 如果你还想提供一个可以被 `nix build` 构建的默认包
    # 例如，让默认包就是 nodejs 本身
    # packages."${system}".default = pkgs.nodejs_20;

    # (可选) 保留你原来的 'dev' 包定义，如果你确实需要它作为一个可构建的包
    # 但通常开发环境使用 devShells 就足够了
    # packages."${system}".dev = let
    #   # ... (你原来的 runCommand 定义) ...
    # in pkgs.runCommand ... ;
  };
}
