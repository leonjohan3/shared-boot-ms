FROM amazoncorretto:17

ARG VERSION=0.0.1-SNAPSHOT
ARG JAR_NAME=shared-boot-ms-${VERSION}.jar

ENV TZ          Australia/Sydney
ENV HOME        /tmp

ARG WORK_DIR=${HOME}/app
ARG HEALTH_CHECK_APP=${HOME}/health_check.py

COPY build/libs/${JAR_NAME} ${HOME}
COPY health_check.py ${HOME}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  echo $TZ > /etc/timezone  && \
    mkdir ${WORK_DIR}  &&  cd ${WORK_DIR}  &&  jar -xf /tmp/${JAR_NAME}  && \
    rm /tmp/${JAR_NAME} && chown nobody ${HEALTH_CHECK_APP} && chmod u+x ${HEALTH_CHECK_APP}

WORKDIR ${HOME}
USER nobody

EXPOSE 8080
ENTRYPOINT ["java", "-Duser.home=/tmp", "-Xms256m", "-Xmx256m", "-XshowSettings", "-cp", "app/BOOT-INF/classes:app/BOOT-INF/lib/*", "org.shared.Application"]
