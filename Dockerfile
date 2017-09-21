FROM mediawiki:lts

RUN \
apt-get update && \
apt-get install --no-install-recommends -y -o Dpkg::Options::="--force-confold" build-essential dvipng ocaml-nox texlive-fonts-recommended texlive-lang-cyrillic texlive-lang-greek texlive-latex-recommended librsvg2-bin python-pygments unzip && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN \
for ext in Math Description2 OpenGraphMeta; do \
curl -fSLo "$ext.tar.gz" "https://github.com/wikimedia/mediawiki-extensions-$ext/archive/$MEDIAWIKI_BRANCH.tar.gz" && \
tar Cxf "extensions" "$ext.tar.gz" && \
mv -fv "extensions/mediawiki-extensions-$ext-$MEDIAWIKI_BRANCH" "extensions/$ext" && \
rm -f "$ext.tar.gz"; done && \
make -C extensions/Math/math && make -C extensions/Math/texvccheck
