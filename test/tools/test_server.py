# A simple local Gemini server that serves files from test/test_assets/.
#
# Some code is borrowed from Gemeaux's documentation (https://github.com/brunobord/gemeaux)
# under the following MIT license:
#
# Copyright (c) 2020 Bruno Bord
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os.path
import subprocess
from gemeaux import App, ArgsConfig, Handler, StaticHandler


def main():
    # Generate certificates if needed
    if not (os.path.isfile("test/certs/cert.pem") and os.path.isfile("test/certs/key.pem")):
        print("Certificates not found - generating new certificates...")
        cert_res = subprocess.run([
            "openssl",
            "req",
            "-new",
            "-x509",
            "-days", "365",
            "-nodes",
            "-out", "test/certs/cert.pem",
            "-keyout", "test/certs/key.pem",
            "-subj", "/CN=localhost",
            "-newkey", "rsa:4096",
            "-addext", "subjectAltName = DNS:localhost,DNS:127.0.0.1"
        ])
        if cert_res.returncode != 0:
            print("Failed to generate certificates - see error message above.")
            exit()
        print("Certificates saved in test/certs/.")

    # Run server
    urls: dict[str, Handler] = {
        "": StaticHandler(
            static_dir="test/test_assets/",
            directory_listing=True
        ),
    }
    config = ArgsConfig()
    config.certfile = "test/certs/cert.pem"
    config.keyfile = "test/certs/key.pem"
    app = App(urls, config)
    app.run()


if __name__ == "__main__":
    main()
