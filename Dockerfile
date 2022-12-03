FROM ortussolutions/commandbox:lucee5

WORKDIR /app

COPY ./app ./

EXPOSE 80 443