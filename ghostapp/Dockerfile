FROM ghost:5.60.0-alpine

# Add app-insights globally
RUN  mkdir /opt/ai && \
    cd /opt/ai && \
    npm init -y && \
    npm install --production --save applicationinsights && \
    npm install --production --save applicationinsights-native-metrics

# Copy the appinsights.js file
COPY appinsights.js /opt/ai/

# Configure AI via ENV VARS
# ENV APPINSIGHTS_INSTRUMENTATIONKEY xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# ENV APPLICATIONINSIGHTS_ROLE_NAME Frontend
# ENV APPLICATIONINSIGHTS_ROLE_INSTANCE GhostInstance
# Lets use platform agnostic node method to load AI instead of monkey patching i.e. NODE_OPTIONS='--require "/opt/ai/appinsights.js"'
ENV NODE_OPTIONS='--require /opt/ai/appinsights.js'

# Add wait-for-it for better startup handling with external database service (https://docs.docker.com/compose/startup-order/)
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh