package com.ks.ci.scripts

import com.ks.ci.builder.KubeInfraBuilder
import javaposse.jobdsl.dsl.JobParent


def factory = this as JobParent
def listOfEnvironment = ["eks-dev", "eks-qa", "eks-prod"]
def component = "kube-infra-job"

def emailId = "vivekmishra22117@gmail.com"
def description = "Pipeline DSL to AWS EKS Infra!"
def displayName = "Kubernetes AWS Infra Job"
def branchesName = "*/master"
def githubUrl = "https://github.com/vivek22117/AWS-k8s-example.git"


new KubeInfraBuilder(
        dslFactory: factory,
        description: description,
        jobName: component + "-" + listOfEnvironment.get(0),
        displayName: displayName + " " + listOfEnvironment.get(0),
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: listOfEnvironment.get(0),
        emailId: emailId
).build()

new KubeInfraBuilder(
        dslFactory: factory,
        description: description,
        jobName: component + "-" + listOfEnvironment.get(1),
        displayName: displayName + " " + listOfEnvironment.get(1),
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: listOfEnvironment.get(1),
        emailId: emailId
).build()

new KubeInfraBuilder(
        dslFactory: factory,
        description: description,
        jobName: component + "-" + listOfEnvironment.get(2),
        displayName: displayName + " " + listOfEnvironment.get(2),
        branchesName: branchesName,
        githubUrl: githubUrl,
        credentialId: 'github',
        environment: listOfEnvironment.get(2),
        emailId: emailId
).build()