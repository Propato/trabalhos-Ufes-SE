#ifndef WEB_H
#define WEB_H

float Get_Wanted_Temp();
float Get_Wanted_Height();

void Server_Init(const char *ssid, const char *password, const char *host);

void handleServer();

#endif // WEB_H