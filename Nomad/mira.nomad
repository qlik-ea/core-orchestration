job "mira-nomad" {
  datacenters = ["dc1"]
  region = "global"
  type = "service"

  group "mira-group" {
    count = 1

    task "mira" {

      driver = "docker"

      config {
        image = "qlikea/mira:0.0.2-396"
        port_map {
          http = 9100
        }

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
        ]

        # Required to be able to access docker.sock
        privileged = true
      }

      env {
        MIRA_MODE = "local" # Currently no specific mira mode for nomad
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "mira"
        port = "http"
        check {
          type = "http"
          path = "/v1/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
