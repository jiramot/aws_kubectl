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
