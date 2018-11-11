package main

import (
  "bytes"
  "os"
  "fmt"
  "log"
  "net"
  "net/http"
  "strings"
)

// const (
//   port = ":8080"
// )

var (
  port = ":8080"
  calls = 0
  hostname = "undefined"
  m = make(map[string]int)
)

func HelloWorld(w http.ResponseWriter, r *http.Request) {
  
  ip, _, err := net.SplitHostPort(r.RemoteAddr)
  if err != nil {
      //return nil, fmt.Errorf("userip: %q is not IP:port", req.RemoteAddr)

      fmt.Fprintf(w, "userip: %q is not IP:port", r.RemoteAddr)
  }

  userIP := net.ParseIP(ip)
  if userIP == nil {
      //return nil, fmt.Errorf("userip: %q is not IP:port", req.RemoteAddr)
      fmt.Fprintf(w, "userip: %q is not IP:port", r.RemoteAddr)
      return
  }

  // This will only be defined when site is accessed via non-anonymous proxy
  // and takes precedence over RemoteAddr
  // Header.Get is case-insensitive
  forward := r.Header.Get("X-Forwarded-For")
  useragent := r.UserAgent()

/*  fmt.Fprintf(w, "<p>IP: %s</p>", ip)
  fmt.Fprintf(w, "<p>Port: %s</p>", port)
  fmt.Fprintf(w, "<p>Forwarded for: %s</p>", forward)
  fmt.Fprintf(w, "<p>User-agent: %s</p>", useragent)
*/
  
  if !(strings.Contains(r.URL.Path, "favicon")) {
    m[fmt.Sprintf("IP: %s | FWDF: %s | UA: %s", ip, forward, useragent)]++
    calls++
  }
  fmt.Fprintf(w, "<p>Hostname: %s</p><p>You have called 'Hello, world!' %d times.</p>", hostname, calls)
  for key, value := range m {
    fmt.Fprintf(w, "%s = %d", key, value)
  } 
}

func init() {
  buf := bytes.NewBufferString("")

  if os.Getenv("PORT") != "" {
    fmt.Fprintf(buf, ":%s", os.Getenv("PORT"))
    port = buf.String()
  }
  fmt.Printf("Started server at http://localhost%v.\n", port)

  hname, err := os.Hostname()
  if err != nil {
    panic(err)
  }
  hostname = hname

  http.HandleFunc("/", HelloWorld)
  log.Fatal(http.ListenAndServe(port, nil))
}

func main() {}
