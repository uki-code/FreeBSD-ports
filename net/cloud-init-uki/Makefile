# Interim home for UKI's pfSense cloud-init port. Structured to move
# wholesale into the poudriere ports tree later (e.g. as net/uki-cloud-init)
# with no logic changes -- it fetches a tagged release of uki-code/cloud-init
# externally via USE_GITHUB, the same way the real upstream FreeBSD port
# (freebsd/freebsd-ports:net/cloud-init) fetches canonical/cloud-init, even
# though both repos happen to be the same checkout during development.
#
# Adapted from that real port's own Makefile (fetched in full while planning
# this) rather than invented from scratch -- see build-port/files/ for the
# patches carried over near-verbatim from it.

PORTNAME=	cloud-init-uki
DISTVERSION=	24.4.1
PORTREVISION=	1
CATEGORIES=	net python
PKGNAMEPREFIX=	${PYTHON_PKGNAMEPREFIX}

# TODO: point at the real UKI team address before this ever actually builds
MAINTAINER=	alex.luehm@ultimateknowledge.com
COMMENT=	UKI cloud-init fork (pfSense support) for use on pfSense images
WWW=		https://github.com/uki-code/cloud-init

LICENSE=	APACHE20 GPLv3
LICENSE_COMB=	dual
LICENSE_FILE_APACHE20=	${WRKSRC}/LICENSE-Apache2.0
LICENSE_FILE_GPLv3=	${WRKSRC}/LICENSE-GPLv3

# Base list carried over from the real net/cloud-init port, plus lxml and
# bcrypt for the pfSense feature (cloudinit/distros/pfsense.py,
# cloudinit/distros/pfsense_utils.py) -- keep in sync with requirements.txt.
RUN_DEPENDS=	${PYTHON_PKGNAMEPREFIX}configobj>0:devel/py-configobj@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}Jinja2>0:devel/py-Jinja2@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}jsonpatch>0:devel/py-jsonpatch@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}jsonpointer>0:devel/py-jsonpointer@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}jsonschema>0:devel/py-jsonschema@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}netifaces>0:net/py-netifaces@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}oauthlib>0:security/py-oauthlib@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}pyserial>0:comms/py-pyserial@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}requests>0:www/py-requests@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}yaml>0:devel/py-yaml@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}lxml>0:devel/py-lxml@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}bcrypt>0:security/py-bcrypt@${PY_FLAVOR} \
		sudo>0:security/sudo

USES=		python shebangfix
USE_GITHUB=	yes
GH_ACCOUNT=	uki-code
GH_PROJECT=	cloud-init
# The exact fork tag to fetch (cloud-init fork versioning: <upstream>+uki<N>,
# decoupled from DISTVERSION above, which must stay ports-clean for
# PKGVERSION comparison -- see the plan this was built from). Override for
# local/CI testing against a candidate tag without editing this file:
#   make GH_TAGNAME=24.4.1+uki2 ...
GH_TAGNAME?=	24.4.1+uki1
USE_PYTHON=	autoplist distutils
PYDISTUTILS_INSTALLARGS+=	"--init-system=sysvinit_freebsd"

SHEBANG_FILES=	tools/hook-hotplug tools/read-dependencies tools/read-version \
		tools/validate-yaml.py

# Conflicts
CONFLICTS_INSTALL=	cloud-init-devel cloud-init

# Standard bsd.port.mk variables
ETCDIR=		${PREFIX}/etc/cloud

NO_ARCH=	yes

MAN1FILES=	cloud-id.1 cloud-init-per.1 cloud-init.1

PLIST_FILES+=	${MAN1FILES:S|^|share/man/man1/|:S|.1$|.1.gz|}

.include <bsd.port.options.mk>

# home_dir (/home vs /usr/home) is deliberately NOT patched here the way the
# real port patches cloudinit/distros/freebsd.py directly -- pfsense.Distro
# (cloudinit/distros/pfsense.py) already carries its own home_dir override,
# which takes effect however cloud-init is installed. See the plan.

.if ${OPSYS} == FreeBSD && ${OSVERSION} >= 1500000
EXTRA_PATCHES+=	${PATCHDIR}/extra-cloudinit_netinfo.py
.endif

.include <bsd.port.pre.mk>


post-patch:
	${REINPLACE_CMD} -e 's|%%PREFIX%%|${STAGEDIR}${PREFIX}|g' ${WRKSRC}/setup.py
	${REINPLACE_CMD} -e 's|%%PREFIX%%|${PREFIX}|g' ${WRKSRC}/cloudinit/settings.py
	${REINPLACE_CMD} -e 's|@@PACKAGED_VERSION@@|${GH_TAGNAME}|g' ${WRKSRC}/cloudinit/version.py
	${RM} ${WRKSRC}/config/cloud.cfg.d/99_freebsd.cfg.orig

post-install:
	${MV} ${STAGEDIR}${ETCDIR}/cloud.cfg ${STAGEDIR}${ETCDIR}/cloud.cfg.sample
	${MV} ${STAGEDIR}${ETCDIR}/cloud.cfg.d/05_logging.cfg ${STAGEDIR}${ETCDIR}/cloud.cfg.d/05_logging.cfg.sample
	${MV} ${STAGEDIR}${ETCDIR}/cloud.cfg.d/99_freebsd.cfg ${STAGEDIR}${ETCDIR}/cloud.cfg.d/99_freebsd.cfg.sample
	${REINPLACE_CMD} -e 's|^.*\.cfg$$|@sample &.sample|'  \
		-e 's|${ETCDIR}/clean.d|@dir ${ETCDIR}/clean.d|' \
		-e 's|${DOCSDIR}/module-docs|@dir ${DOCSDIR}/module-docs|' \
		${_PYTHONPKGLIST}
.for man in ${MAN1FILES}
		${INSTALL_MAN} ${WRKSRC}/doc/man/${man} ${STAGEDIR}${PREFIX}/share/man/man1
.endfor

.include <bsd.port.post.mk>
