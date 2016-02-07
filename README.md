# HOW-TO

## Before

1. Install docker on host machine
2. Add ```app``` to your /etc/hosts with host IP address. Some apps remember host
   name in db when you visit site/admin.

### Build app image

First step is to build image with installed shopping cart (all files are copied
to image)

```
cd woocommerce/app
docker build -t payfortstart/woocommerce-app .
```

Next we need to configure shopping cart: create tables in db, fill in them with
some data, create test product

```
docker run -d --name app -p 80:80 payfortstart/woocommerce-app
# => container-id
```

Now open your browser at ```http://app``` and do configuration and add Demo Product.

After we add Demo Product we are ready to create snapshot of ```configured```
image. Use ```container-id``` from previous step:

```
docker commit -m "Configure application" container-id payfortstart/woocommerce-app:configured
docker push payfortstart/woocommerce-app:configured
```

### Build test image

```
docker build -t payfortstart/woocommerce-test .
docker push payfortstart/woocommerce-test
```

You can run tests on host machine too:

```
cd woocommerce-plugin
docker build -t woocommerce-plugin .
docker run --name app -d woocommerce-plugin
docker run --link app:app payfortstart/woocommerce-test /bin/sh -c "xvfb-run -a  bundle exec rspec"
```

Also, if you want to run tests manually from woocommerce-test containers:

```
run -ti payfortstart/woocommerce-test /bin/bash
# xvfb-rin -a bundle exec rspec
```

(c) Copyright Payfort.

[The MIT License (MIT)](/LICENSE)
