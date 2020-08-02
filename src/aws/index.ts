import * as awsx from "@pulumi/awsx";

// Create a load balancer on port 80 and spin up two instances of Nginx.
const lb = new awsx.lb.ApplicationListener("crystal", { port: 80 });
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

// Export the load balancer's address so that it's easy to access.
export const url = lb.endpoint.hostname;