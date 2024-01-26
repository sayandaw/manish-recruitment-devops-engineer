# Use alpine version of the tomcat 8 image as its fast, lightweight and the small footprint reduces attack surface
FROM tomcat:8.0-alpine

# Install wget to download the file
RUN apk add --no-cache wget

# Get the Sample app from https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/
RUN wget https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/sample.war -O /usr/local/tomcat/webapps/sample.war

# Expose the port 8080 on which the app runs by default as per the documentation, App is now available on http://localhost:8080/sample/
EXPOSE 8080