ARG RUNTIME=public.ecr.aws/lambda/nodejs:18
FROM ${RUNTIME}
RUN yum update -y
RUN yum install -y zip unzip
COPY . .
RUN npm install --production
RUN zip -9r package.zip index.js node_modules package*.json
RUN npm install

