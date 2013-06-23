// set GOROOT necessary if not self-installed 
// The GOPATH environment variable lists places to look for Go code
package main

import (
  "fmt"
  "os"
  "net/http"
  "bytes"
  "log"
  "io/ioutil"
  "encoding/json"
)

type apiResponse struct {
  Id, Kind,longUrl string
}

func main() {
  longUrl := os.Args[len(os.Args) - 1]

  body := bytes.NewBufferString(fmt.Sprintf(
    `{"longUrl": "%s"}`,
    longUrl))

  request, err := http.NewRequest(
    "POST",
    "https://www.googleapis.com/urlshortener/v1/url",
    body)
  if err != nil {
    log.Fatal(err)
  }

  request.Header.Add("Content-Type","application/json")

  clinet := &http.Client{}

  response ,err := clinet.Do(request)

  if err != nil {
    log.Fatal(err)
  }

  outputAsBytes, err := ioutil.ReadAll(response.Body)

  if err != nil {
        log.Fatal(err)
  }
  defer response.Body.Close()


  var output apiResponse
  err = json.Unmarshal(outputAsBytes,&output)

  if err != nil {
    log.Fatal(err)
  }
  
  fmt.Printf("%s\n",output.Id)
}