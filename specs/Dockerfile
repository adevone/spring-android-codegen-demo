FROM swaggerapi/swagger-ui

ENV URLS="[ { name: \"client\", url: \"/client.json\"}, { name: \"panel\", url: \"/panel.json\" }, { name: \"integrate\", url: \"/integrate.json\" } ]"

#ENV SWAGGER_JSON=/client.json
ENV DISPLAY_OPERATION_ID="true"

COPY specs/client.json /usr/share/nginx/html/client.json
COPY specs/panel.json /usr/share/nginx/html/panel.json
COPY specs/integrate.json /usr/share/nginx/html/integrate.json