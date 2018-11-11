FROM scratch
ADD main /
ENV PORT 8080
EXPOSE 8080
CMD ["/main"]