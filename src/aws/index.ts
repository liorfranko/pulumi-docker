import * as awsx from "@pulumi/awsx";
// TODO rebuild from scratch using @pulumi/aws and use the forntend_port/backend_port/listen_addr as variables on the LB and SG objects
const forntend_port = 80
const backend_port = 80
const listen_addr = "0.0.0.0"

const repo = new awsx.ecr.Repository("crystal-repo");
const image = repo.buildAndPushImage({
    context: "./crystal-docker",
    cacheFrom: true,
    args: {"LISTEN_ADDR" : listen_addr, "LISTEN_PORT": backend_port.toString()}
});


// Create a load balancer listening on "forntend_port"
// Change the health path and deregistrationDelay and target port
const lb = new awsx.lb.ApplicationListener("crystal-alb", { 
    port: 80,
    targetGroup: {
        port: 80,
        deregistrationDelay: 0, // Much faster for Dev tests
        healthCheck: {
            path: "/health"
        }
    }
});

// Spin up two instances of crystal docker.
const crystal = new awsx.ecs.FargateService("crystal-fargate", {
    taskDefinitionArgs: {
        containers: {
            crystal: {
                image: image,
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