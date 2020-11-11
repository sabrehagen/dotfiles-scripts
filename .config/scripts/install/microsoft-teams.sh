# Install microsoft teams
RUN wget -O MsTeams.deb https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_1.3.00.5153_amd64.deb && \
    apt install ./MsTeams.deb -q -y
