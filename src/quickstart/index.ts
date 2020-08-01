import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

const defaultInstance = new gcp.compute.Instance("default", {
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
        network: "vpc-prod",
        subnetwork: "vpc-prod"
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
    zone: "us-east4-c",
});