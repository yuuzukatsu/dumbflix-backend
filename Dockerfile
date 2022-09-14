FROM node:10
WORKDIR /app
COPY . .
RUN npm install
RUN npm install sequelize-cli
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +x wait-for-it.sh
RUN echo '#!/bin/bash' > start-server.sh
RUN echo 'npx sequelize-cli db:migrate' >> start-server.sh
RUN echo 'npm start' >> start-server.sh
RUN chmod +x start-server.sh
EXPOSE 5000
CMD ["npm", "start"]
