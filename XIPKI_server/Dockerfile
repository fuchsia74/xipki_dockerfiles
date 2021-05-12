FROM tomcat:9.0.45-jdk11-adoptopenjdk-openj9
MAINTAINER fuchsia

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

ENV XIPKI_MAJOR 5
ENV XIPKI_VERSION 5.3.11

#ENV CA_WAR_SHA256 e66bf806823c51ef21cf35d17786576dd464cfe5222e413e283ab12a003192d2
#ENV OCSP_WAR_SHA256 9cf95f12f341179df4effbbf89c7e4c32256c794647aed013f07def43411b4df 

WORKDIR $CATALINA_HOME

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		wget unzip\
	; \
	\
	ddist() { \
		local f="$1"; \
		local distFile="$1"; \
		local success=; \
		local distUrl=; \
		for distUrl in \
			"https://github.com/xipki/xipki/releases/download/v${XIPKI_VERSION}/$distFile" \
			"https://www.bouncycastle.org/download/$distFile" \
		; do \
			if wget -O "$f" "$distUrl" --progress=dot:giga && [ -s "$f" ]; then \
				success=1; \
				break; \
			fi; \
		done; \
		[ -n "$success" ]; \
	}; \
	\
	ddist ca-war-$XIPKI_VERSION.zip ; \
#	echo "$CA_WAR_SHA256  ca-war-$XIPKI_VERSION.zip" | sha256sum --strict --check -; \
	ddist ocsp-war-$XIPKI_VERSION.zip ; \
#	echo "$OCSP_WAR_SHA256  ocsp-war-$XIPKI_VERSION.zip" | sha256sum --strict --check -; \
	\
	unzip ca-war-$XIPKI_VERSION.zip; \
	rm ca-war-$XIPKI_VERSION.zip ; \
	mv ca-war-$XIPKI_VERSION/webapps/* webapps/ ; \
	mv ca-war-$XIPKI_VERSION/lib/* lib/ ; \
	mv ca-war-$XIPKI_VERSION/xipki ./ ;\
	rm -rf ca-war-$XIPKI_VERSION ;\
	\
	unzip ocsp-war-$XIPKI_VERSION.zip; \
	rm ocsp-war-$XIPKI_VERSION.zip; \
	mv ocsp-war-$XIPKI_VERSION/webapps/* webapps/ ; \
	mv ocsp-war-$XIPKI_VERSION/xipki/etc/ocsp xipki/etc/ ; \
	mv ocsp-war-$XIPKI_VERSION/xipki/crls xipki/ ; \
	mv ocsp-war-$XIPKI_VERSION/xipki/keycerts/ocsp1.p12 xipki/keycerts/ ; \
	rm -rf ocsp-war-$XIPKI_VERSION ;\
	\
	ddist bcpkix-jdk15on-168.jar ; \ 
	ddist bcprov-jdk15on-168.jar ; \
	mv bcpkix-jdk15on-168.jar  bcprov-jdk15on-168.jar lib/ ; \
	\
	for distFile in \
            "xipki/etc/ca/database/ca-db.properties" \
            "xipki/etc/ca/database/mariadb/ca-db.properties" \
            "xipki/etc/ca/database/mariadb/ocsp-db.properties" \
            "xipki/etc/ocsp/database/ca-db.properties" \
            "xipki/etc/ocsp/database/mariadb/ca-db.properties" \
            "xipki/etc/ocsp/database/mariadb/ocsp-cache-db.properties" \
            "xipki/etc/ocsp/database/mariadb/ocsp-crl-db.properties" \
            "xipki/etc/ocsp/database/mariadb/ocsp-db.properties" \
    ; do \
            sed "s/127.0.0.1/XIPKI_Mysql/" -i $distFile ; \
    done ;\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; 

COPY server.xml conf/server.xml
COPY setenv.sh bin/setenv.sh
	
EXPOSE 8080
EXPOSE 8443
