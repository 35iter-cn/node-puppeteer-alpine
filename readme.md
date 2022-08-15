## puppeteer 镜像

拿来就用，支持 amd64（x84_64） 和 arm64 架构。使用方法：

```
docker pull rxh1212/node-puppeteer-alpine

```

本地测试好代码并打包以后，以 `rxh1212/node-puppeteer-alpine` 为基础镜像制作包含你代码的镜像，然后运行即可。

### 🌰示例

制作镜像所需的 dockerfile：

``` dockerfile

FROM rxh1212/node-puppeteer-alpine as builder


# 默认工作路径设置为用户目录下的子目录
WORKDIR /home/pptruser/app

# 将源码拷贝至 builder 中
COPY . .

# 打包，假设产出目录为 dist
RUN yarn && yarn build


# 启动 prod 
FROM rxh1212/node-puppeteer-alpine as prod

WORKDIR /home/pptruser/app

# 将 builder 打包后的产物拷贝至 prod 并将用户权限更正为 pptruser:pptruser
COPY --chown=pptruser:pptruser --from=builder /home/pptruser/app/dist /home/pptruser/app/dist
COPY --chown=pptruser:pptruser --from=builder /home/pptruser/app/package.json /home/pptruser/app/package.json
COPY --chown=pptruser:pptruser --from=builder /home/pptruser/app/yarn.lock /home/pptruser/app/yarn.lock

EXPOSE 3000

# 运行时安装依赖，减小镜像提及
CMD yarn install --prod && yarn start:prod
```

制作镜像：

```
docker build -t <imagename>:<tag> .
```

启动一个镜像实例：

```
docker run --name puppeteer -d -p 3000:3000 <imagename>:<tag>
```

## 功能

- 支持中文字体
- 提供了 pptruser 用户，应用代码拷贝至：`/home/pptruser` 目录，默认使用 pptruser 用户执行代码。
- 默认配置 `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true`，`PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser`。执行 yarn install puppeteer 的时候会跳过 Chromium 的安装。

## 说明

为避免系统文件遭到修改，puppeteer 不建议使用 root 用户运行脚本，所以本项目提供的镜像默认使用 puppeteer 用户。也正因为如此，推荐将应用代码拷贝至 puppeteer 用户目录执行。