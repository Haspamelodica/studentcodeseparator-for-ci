#!/bin/bash

#TODO don't tag with fixed name charon:student! Instead, somehow transmit the ID.
exec docker build -t charon:student -f student.Dockerfile .
