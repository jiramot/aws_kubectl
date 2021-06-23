# Usage Jenkins pod template
```
pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: gradle
    image: gradle
    tty: true
    command:
    - cat
    volumeMounts:
    - mountPath: /home/gradle/.gradle
      name: gradle
  - name: docker
    image: docker:19.03.8
    tty: true
    command:
    - cat
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker
  - name: kubectl
    image: jiramot/aws_kubectl:2
    tty: true
    command:
    - cat
  volumes:
  - name: gradle
    hostPath:
      path: /home/jenkins/.gradle
  - name: docker
    hostPath:
      path: /var/run/docker.sock
'''
            defaultContainer 'gradle'
        }
    }
    stages {
        stage('Main') {
            steps {
                container('kubectl') {
                    withAWS(credentials: 'aws_credentials', region: 'ap-southeast-1') {
                        withKubeConfig([credentialsId: 'kube_credentials', serverUrl: 'https://kubeserver]) {
                            sh "kubectl get namespaces"
                        }
                    }
                }
            }
        }
    }
}
```

## Docker Hub
docker push jiramot/aws_kubectl:2

## Version
- 3: Update kubectl and aws-cli 
```
aws-cli/1.19.98 Python/3.9.5 Linux/5.10.25-linuxkit botocore/1.20.98
bash-5.1# kubectl version --client
Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.0", GitCommit:"cb303e613a121a29364f75cc67d3d580833a7479", GitTreeState:"clean", BuildDate:"2021-04-08T16:31:21Z", GoVersion:"go1.16.1", Compiler:"gc", Platform:"linux/amd64"}
```