package main

import (
	"github.com/micro/examples/helloworld/handler"
	pb "github.com/micro/examples/helloworld/proto"
	"github.com/micro/go-micro"
	"github.com/micro/go-micro/v2/logger"
)

func main() {
	// New Service
	helloworld := micro.NewService(
		micro.Name("helloworld"),
	)

	// Initialise service
	helloworld.Init()

	// Register Handler
	pb.RegisterHelloworldHandler(helloworld.Server(), new(handler.Helloworld))

	// Run service
	if err := helloworld.Run(); err != nil {
		logger.Fatal(err)
	}
}
