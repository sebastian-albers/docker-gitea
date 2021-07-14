# Gitea

[![Build Status](https://github.com/sebastian-albers/docker-gitea/actions/workflows/main.yml/badge.svg)](https://github.com/sebastian-albers/docker-gitea/actions/workflows/main.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/sebastianalbers/gitea.svg)
![Docker Stars](https://img.shields.io/docker/stars/sebastianalbers/gitea.svg)

Gitea is a community managed painless self-hosted Git service. You can see a Gitea demo [here](https://try.gitea.io/) (running on tip).

For more information, check out the [official project on GitHub](https://github.com/go-gitea/gitea), and for instructions on how to set up, their [documentation](https://docs.gitea.io/).

Unlike the [official Gitea repository](https://hub.docker.com/r/gitea/gitea), this repository also provides images for `arm32v7` that can be executed on Raspbian for example.

## Quick set-up
docker-compose file (with description):

Use this docker-compose file to get up and running quickly. You should change mysql user- and root password. When installing, you can reference the database container as host db.

This configuration will publicly expose ports 3000 and 22.

    version: '2'
    services:
      web:
        image: sebastianalbers/gitea:1.11.1
        volumes:
          - ./data:/data
        ports:
          - "3000:3000"
          - "22:22"
        depends_on:
          - db
        restart: always
      db:
        image: mariadb:10
        restart: always
        environment:
          - MYSQL_ROOT_PASSWORD=changeme
          - MYSQL_DATABASE=gitea
          - MYSQL_USER=gitea
          - MYSQL_PASSWORD=changeme
        volumes:
          - ./db/:/var/lib/mysql

