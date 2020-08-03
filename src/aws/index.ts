import * as awsx from "@pulumi/awsx";
import * as docker from "@pulumi/docker";
import * as aws from "@pulumi/aws";

let forntend_port = 80
let backend_port = 80

const repo = new awsx.ecr.Repository("crystal");
const image = repo.buildAndPushImage({
    context: "./crystal-docker",
    cacheFrom: true,
    // env: {"LISTEN_ADDR" : "0.0.0.0", "LISTEN_PORT": backend_port.toString()}
});


// Create a load balancer on port 80, change the health path and deregistrationDelay
const lb = new awsx.lb.ApplicationListener("crystal", { 
    port: forntend_port,
    targetGroup: {
        port: backend_port,
        deregistrationDelay: 0, // Much faster for Dev tests
        healthCheck: {
            path: "/health"
        }
    }
});

// Spin up two instances of crystal docker.
const crystal = new awsx.ecs.FargateService("crystal", {
    taskDefinitionArgs: {
        containers: {
            crystal: {
                image: image,
                // image: "docker.io/liorf1/crystal_docker",
                memory: 1024,
                portMappings: [ lb ],
                cpu: 4096,
            }
        },
    },
    desiredCount: 2,
});

// Export the load balancer's address.
export const url = lb.endpoint.hostname;