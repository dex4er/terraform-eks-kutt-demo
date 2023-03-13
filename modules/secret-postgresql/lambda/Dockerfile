FROM public.ecr.aws/sam/build-python3.9:1 AS build

RUN yum install -y postgresql-devel && yum clean all

## Test if script can run
# COPY requirements.txt ./
# RUN pip install -r requirements.txt --prefix= --target=.
# COPY lambda_function.py ./
# RUN python3 lambda_function.py
# FROM public.ecr.aws/sam/build-python3.9:latest
# COPY --from=build /var/task/ /var/task/
# COPY --from=build /lib64/liblber-2.4.so.2 /lib64/libldap_r-2.4.so.2 /lib64/libnss3.so /lib64/libpq.so.5 /lib64/libsasl2.so.3 /lib64/libsmime3.so /lib64/libssl3.so ./
# RUN python3 lambda_function.py
