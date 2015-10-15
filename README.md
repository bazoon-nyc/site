# site

Deployment to EB.

cd /path/to/project/root
zip bn-deploy.zip Dockerrun.aws.json -r src/ -r .ebextensions/
Upload & Deploy to environment via AWS console.