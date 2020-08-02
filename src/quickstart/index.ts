import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";
import * as k8s from "@pulumi/kubernetes";

const defaultInstance = new gcp.compute.Instance("default", {
    // project: "sturdy-pier-271315",
    bootDisk: {
        initializeParams: {
            image: "debian-cloud/debian-9",
        },
    },
    machineType: "n1-standard-1",
    metadata: {
        foo: "bar",
    },
    metadataStartupScript: "echo hi > /test.txt",
    networkInterfaces: [{
        network: "default",
    }],
    // Local SSD disk
    scratchDisks: [{
        interface: "SCSI",
    }],
    serviceAccount: {
        scopes: [
            "userinfo-email",
            "compute-ro",
            "storage-ro",
        ],
    },
    tags: [
        "foo",
        "bar",
    ],
    zone: "europe-west1",
});


const name = "helloworld";

// Create a GKE cluster
const cluster = new gcp.container.Cluster(name, {
    initialNodeCount: 2,
    minMasterVersion: "1.16.13-gke.1",
    nodeVersion: "1.16.13-gke.1",
    network: 'default',
    // project: 'sturdy-pier-271315',
    nodeConfig: {
        machineType: "n1-standard-1",
        oauthScopes: [
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring"
        ],
    },
});

// Export the Cluster name
export const clusterName = cluster.name;

// Manufacture a GKE-style kubeconfig. Note that this is slightly "different"
// because of the way GKE requires gcloud to be in the picture for cluster
// authentication (rather than using the client cert/key directly).
export const kubeconfig = pulumi.
    all([ cluster.name, cluster.endpoint, cluster.masterAuth ]).
    apply(([ name, endpoint, masterAuth ]) => {
        const context = `${gcp.config.project}_${gcp.config.zone}_${name}`;
        return `apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${masterAuth.clusterCaCertificate}
    server: https://${endpoint}
  name: ${context}
contexts:
- context:
    cluster: ${context}
    user: ${context}
  name: ${context}
current-context: ${context}
kind: Config
preferences: {}
users:
- name: ${context}
  user:
    auth-provider:
      config:
        cmd-args: config config-helper --format=json
        cmd-path: gcloud
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp
`;
    });

// Create a Kubernetes provider instance that uses our cluster from above.
const clusterProvider = new k8s.Provider(name, {
    kubeconfig: kubeconfig,
});