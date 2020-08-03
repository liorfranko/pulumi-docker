import * as awsx from "@pulumi/awsx";

// Create a load balancer on port 80, change the health path and deregistrationDelay
const lb = new awsx.lb.ApplicationListener("crystal", { 
    port: 80,
    targetGroup: {
        port: 80,
        deregistrationDelay: 0, // Much faster for Dev tests
        healthCheck: {
            path: "/health"
        }
    }
});

// Spin up two instances of Customer crystal docker.
const crystal = new awsx.ecs.FargateService("crystal", {
    taskDefinitionArgs: {
        containers: {
            crystal: {
                image: "docker.io/liorf1/crystal_docker",
                memory: 1024,
                portMappings: [ lb ],
                cpu: 4096
            }
        },
    },
    desiredCount: 2,
});

// Export the load balancer's address.
export const url = lb.endpoint.hostname;