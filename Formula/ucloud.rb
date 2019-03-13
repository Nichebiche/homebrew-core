class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.11.tar.gz"
  sha256 "9335b68d5d6330e6270c5a3dae387d6ce040fa3179776988ad0d2af60cca05ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "612b0231bc43a50be8ddcaffcf4b0e326b892ad198760acee761a797834d9828" => :mojave
    sha256 "44c9fefe62d4242f9b10dcd2894002f5ce20728968f6c847fac96b1c5ee398c8" => :high_sierra
    sha256 "951bde9a5d70f1d3d42f2de81469e3665984092595d7ed4da531ff2b56a7d111" => :sierra
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
