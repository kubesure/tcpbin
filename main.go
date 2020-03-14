package main

import (
	"log"
	"net"
)

func main() {
	l, err := net.Listen("tcp", ":8090")
	if err != nil {
		log.Fatal(err)
	}

	defer l.Close()

	for {
		log.Println("server accepting connection")
		conn, err := l.Accept()

		if err != nil {
			log.Printf("Error while accepting conn %v", conn)
			log.Fatal(err)
		}
		go handleRequest(conn)
	}
}

func handleRequest(conn net.Conn) {
	buff := make([]byte, 1024)
	len, err := conn.Read(buff)
	if err != nil {
		log.Printf("error while reading bytes %v", err)
	}
	log.Printf("lenghth message received %v message %s", len, string(buff[:]))
	conn.Write([]byte("status|ok"))
	conn.Close()
}
