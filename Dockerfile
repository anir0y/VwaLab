FROM debian:latest

LABEL maintainer="mail@anir0y.in"
LABEL version="E.1.3"

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget debconf-utils apache2 mariadb-server php php-mysql php-pgsql php-pear php-gd && \
    echo "mariadb-server mariadb-server/root_password password vulnerables" | debconf-set-selections && \
    echo "mariadb-server mariadb-server/root_password_again password vulnerables" | debconf-set-selections && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy application files

COPY vwa /var/www/html
COPY db.sql /docker-entrypoint-initdb.d/db.sql

# Copy main.sh
RUN echo "IyEvYmluL2Jhc2gKZWNobyAiUnVubmluZyBtYWluLnNoIgojIENyZWF0ZSBuZWNlc3NhcnkgZGlyZWN0b3JpZXMKbWtkaXIgLXAgL3Zhci93d3cvaHRtbC9pbWFnZXMKcm0gLXJmIC92YXIvd3d3L2h0bWwvaW5kZXguaHRtbAojIFNldCBwZXJtaXNzaW9ucwpjaG1vZCA3NzcgLVIgL3Zhci93d3cvaHRtbC9pbWFnZXMKY2hvd24gd3d3LWRhdGE6d3d3LWRhdGEgLVIgL3Zhci93d3cvaHRtbAojIFN0YXJ0IE15U1FMCmVjaG8gJ1srXSBTdGFydGluZyBteXNxbC4uLicKbXlzcWxkX3NhZmUgJgpzbGVlcCA1CiMgSW5pdGlhbGl6ZSB0aGUgZGF0YWJhc2UgaWYgbmVlZGVkCmlmIFsgISAtZCAiL3Zhci9saWIvbXlzcWwvdndhIiBdOyB0aGVuCiAgICBlY2hvICJJbml0aWFsaXppbmcgZGF0YWJhc2UuLi4iCiAgICBteXNxbF9pbnN0YWxsX2RiIC0tdXNlcj1teXNxbCAtLWxkYXRhPS92YXIvbGliL215c3FsLwogICAgbXlzcWxkX3NhZmUgJgogICAgc2xlZXAgNQogICAgbXlzcWwgLXVyb290IC1lICJDUkVBVEUgVVNFUiAnYXBwJ0AnbG9jYWxob3N0JyBJREVOVElGSUVEIEJZICd2dWxuZXJhYmxlcyc7IENSRUFURSBEQVRBQkFTRSB2d2E7IEdSQU5UIEFMTCBQUklWSUxFR0VTIE9OIHZ3YS4qIFRPICdhcHAnQCdsb2NhbGhvc3QnOyIKICAgIG15c3FsIC11cm9vdCAtcHZ1bG5lcmFibGVzIHZ3YSA8IC9kb2NrZXItZW50cnlwb2ludC1pbml0ZGIuZC9kYi5zcWwKICAgIG15c3FsYWRtaW4gLXVyb290IHNodXRkb3duCmZpCiMgUmVzdGFydCBNeVNRTCB0byBlbnN1cmUgaXQncyBydW5uaW5nIHdpdGggbmV0d29ya2luZwplY2hvICdbK10gUmVzdGFydGluZyBteXNxbC4uLicKbXlzcWxkX3NhZmUgJgpzbGVlcCA1CiMgU3RhcnQgQXBhY2hlCmVjaG8gJ1srXSBTdGFydGluZyBhcGFjaGUnCnNlcnZpY2UgYXBhY2hlMiBzdGFydAojIEtlZXAgY29udGFpbmVyIHJ1bm5pbmcKdGFpbCAtZiAvdmFyL2xvZy9hcGFjaGUyLyogL3Zhci9sb2cvbXlzcWwvKiAmCndhaXQK" | base64 -d > /main.sh

# Set script permissions
RUN chmod +x /main.sh
# Expose port 80
EXPOSE 80
# Set entrypoint
ENTRYPOINT ["/main.sh"]
