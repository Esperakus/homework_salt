#!/bin/bash

sleep 30
salt '*' state.highstate
