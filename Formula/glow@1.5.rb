class GlowAT15 < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "b4ecf269b7c6447e19591b1d23f398ef2b38a6a75be68458390b42d3efc44b92"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

      generate_completions_from_executable(bin/"glow@1.5", "completion")
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS

    # failed with Linux CI run, but works with local run
    # https://github.com/charmbracelet/glow/issues/454
    if OS.linux?
      system bin/"glow", test_file
    else
      assert_match "# header", shell_output("#{bin}/glow #{test_file}")
    end
  end
end
