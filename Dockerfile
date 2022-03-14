# This base image starts up mongo
# This version needs to correspond with the helm chart version
ARG MONGODBVERSION=4.0.12

FROM bitnami/mongodb:${MONGODBVERSION} as build

# Use .dockerignore file to ignore unwanted files
# These files are used by import_mongo.sh to initialize mongo
# Creating directories as root
# Set user back to the one in base image
USER root
RUN mkdir -p /data
COPY data/ /data/
USER 1001

RUN echo "Hello World!!!!!!!!!"
# Import data into mongodb

ARG ARG_REF_ENSEMBL_VERSION
ENV REF_ENSEMBL_VERSION=${ARG_REF_ENSEMBL_VERSION}
# ARG COPY_REF_ENSEMBL_VERSION=$ARG_REF_ENSEMBL_VERSION
# ENV REF_ENSEMBL_VERSION=$COPY_REF_ENSEMBL_VERSION

RUN echo REF_ENSEMBL_VERSION
RUN echo "above has no money but lower has money"
RUN echo $REF_ENSEMBL_VERSION
RUN echo "kuohao REF_ENSEMBL_VERSION kuohao"
RUN echo ${REF_ENSEMBL_VERSION}

RUN echo "ARG_REF_ENSEMBL_VERSION with money"
RUN echo $ARG_REF_ENSEMBL_VERSION
RUN echo "ARG_REF_ENSEMBL_VERSION no money"
RUN echo ARG_REF_ENSEMBL_VERSION
RUN echo "ARG_REF_ENSEMBL_VERSION no kuohao money kuohao"
RUN echo ${ARG_REF_ENSEMBL_VERSION}





COPY scripts/import_mongo.sh /docker-entrypoint-initdb.d/
RUN /setup.sh

FROM bitnami/mongodb:${MONGODBVERSION}
COPY --from=build /bitnami/mongodb /bitnami/seed
COPY /scripts/startup.sh /startup.sh

CMD [ "/startup.sh" ]