# $FreeBSD$

PORTNAME=	repoc
DISTVERSION=	20230912
CATEGORIES=	sysutils
PKGNAMEPREFIX=	pfSense-

MAINTAINER=	luiz@netgate.com
COMMENT=	pfSense dynamic repository client

LIB_DEPENDS=	libucl.so:textproc/libucl

PLIST_FILES=	sbin/pfSense-repoc \
		sbin/pfSense-repoc-static

# --- Closed-source repackaging: fetch the pre-built .pkg instead of source ---
MASTER_SITES=	${EXT_PKG_CACHE_URL}/pfsense/pkgs/
DISTFILES=		${PKGNAMEPREFIX}${PORTNAME}-${DISTVERSION}.pkg
EXTRACT_ONLY=	# Disable automatic extraction; we handle it ourselves
NO_BUILD=		yes  # Nothing to compile

# --- Closed-source repackaging: extract pre-built .pkg ---
do-extract:
		@${MKDIR} ${WRKSRC}
		cd ${WRKSRC} && ${TAR} xf ${DISTDIR}/${PKGNAMEPREFIX}${PORTNAME}-${DISTVERSION}.pkg \
			--exclude='+*'

# --- Closed-source repackaging: re-pack pre-built .pkg ---
do-install:
	cd ${WRKSRC}/usr/local && ${COPYTREE_BIN} . ${STAGEDIR}${PREFIX}

.include <bsd.port.mk>
