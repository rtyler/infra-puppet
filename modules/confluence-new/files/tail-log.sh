#!/bin/bash
exec tail -F ~/home/logs/atlassian-confluence.log ~/current/logs/catalina.out
