# Ag Cur Tús Leis

Suiteáiltear Omarchy le ISO. Is féidir leat rogha a dhéanamh idir suiteáil lán-diosca, a ghlacann an tiomántán ar fad, nó suiteáil spáis shaor, a chuireann Omarchy sa spás neamh-leithdháilte ar thiomántán — sin é an chaoi a ndéanann tú dé-thosú in éineacht le Windows nó córas oibriúcháin eile (féach [suiteáil dé-thosaithe](50-dual-boot-install.md) — tabhair faoi deara go mbeidh ort BitLocker a mhúchadh i Windows ar dtús). Ar aon slí, is criptiú iomlán an réamhshocrú don tsuiteáil, agus scriosfaidh an rogha lán-diosca an tiomántán roghnaithe, mar sin bí cinnte cúltaca a dhéanamh sula n-úsáideann tú ceann atá ann cheana!

[Íoslódáil ISO Omarchy](https://omarchy.org/) ar dtús, cuir ar mhéaróg USB é (úsáid [balenaEtcher](https://etcher.balena.io/) ar Mac/Windows nó [caligula](https://github.com/ifd3f/caligula) ar Linux), agus tosaigh ón méaróg.

_Caithfidh tú Secure Boot agus/nó TPM a mhúchadh sa BIOS. Caithfidh tú iad seo a mhúchadh chun Omarchy a bheith in ann a shuiteáil. Is scéimeanna slándála Microsoft iad atá ceaptha do Windows agus do dháiltí Linux atá cleamhnaithe le Microsoft._

Ansin freagair na ceisteanna cumraíochta, agus deimhnigh iad mar seo:

 ![install-config](images/install-config.webp)

Ansin roghnaigh tiomántán do do shuiteáil, agus suigh siar agus féach ar sheó na suiteála. Is féidir é a dhéanamh i níos lú ná nóiméad ar na meaisíní nua-aimseartha is tapúla, ach níor cheart go dtógfadh sé níos mó ná 5 nóiméad fiú ar ríomhaire níos sine.

 ![install-done](images/install-done.webp)

Anois tá tú réidh le haghaidh Omarchy!

### Úsáid méarchlár sreangaithe nó 2.4ghz!

Ní ligfidh an criptiú lán-diosca duit an pasfhocal a iontráil ó mhéarchlár Bluetooth ag an am tosaithe. Díreach mar nach féidir leat méarchlár Bluetooth a úsáid chun dul isteach sa BIOS ar PC. Beidh méarchlár uait a úsáideann dongal 2.4ghz nó cábla (atá i bhfad níos deise ó thaobh moille de ar aon nós!). Is breá liom féin an [Lofree Flow84](https://www.lofree.co/products/lofree-flow-the-smoothest-mechanical-keyboard)!

### Suiteáil d'úinéir eile

Má tá tú ag socrú meaisín do dhuine eile — ball teaghlaigh, fostaí nua, ceannaitheoir — níor cheart duit a bheith ag freagairt na gceisteanna pearsanta ar a son. Buail `Ctrl + C` ar an gcéad scáileán den suiteálaí (roghnú an mhéarchláir), agus tairgfidh Omarchy an meaisín a ullmhú d'úinéir eile ina ionad. Suiteáiltear an córas láithreach, ach cuirtear an socrú pearsanta ar fad — leagan amach an mhéarchláir, ainm úsáideora, pasfhocal — siar go dtí go dtosaíonn an meaisín den chéad uair. Tá an tiomántán criptithe de réir réamhshocraithe fós, agus éiríonn an pasfhocal a roghnaíonn an t-úinéir nua ar an gcéad tosú sin ina phasfhocal criptithe freisin. (Is féidir meaisín atá in úsáid agat cheana a thabhairt ar aghaidh gan athshuiteáil freisin — féach [an ríomhaire a athshocrú](48-security.md).)

### Suiteálacha gan duine i láthair

Is féidir leis an ISO suiteáil go hiomlán leis féin freisin — gan méarchlár, gan treoraí — nuair a thugtar a chumraíocht dó ar an dara tiomántán. Sin an chaoi le Omarchy a láimhseáil mar bhuníomhá do VManna agus do mheaisíní cabhlaigh. Féach [suiteálacha gan duine i láthair](51-unattended-installs.md).

### Suiteálacha gan chriptiú

Suiteáiltear Omarchy le criptiú de réir réamhshocraithe. Is é an rogha shábháilte, fhreagrach é d'aon ríomhaire a d'fhéadfadh a bheith caillte nó goidte. Níl tú ag iarraidh go mbeadh duine ar bith a bhfuil rochtain aige ar do chrua-earraí in ann do shonraí a fháil!

Ach in imthosca speisialta, cosúil le suiteálacha Omarchy cianda ar ríomhairí cosanta nó do shuiteálacha caithimh gan sonraí íogaire, b'fhéidir gur mhaith leat suiteáil gan chriptiú. Is féidir leat `Ctrl + C` a bhualadh ar dheimhniú formáidithe an diosca chun athrú go suiteáil gan chriptiú.

### Teanga

Labhraíonn Omarchy 50 teanga — an tacar céanna le omarchy.org — agus is é an Béarla an réamhshocrú. Chun athrú, oscail roghchlár Omarchy agus téigh go _Socrú > Teanga_, nó rith `omarchy language <code>` i teirminéal (taispeánann `omarchy language list` na cóid). Athraíonn an roghchlár, an deasc, agus fógraí Omarchy féin teanga láithreach, agus socraítear logchaighdeán an chórais chun meaitseáil, mar sin leanann d'fheidhmchláir eile an chéad uair eile a logálann tú isteach.

### Cabhair má tá tú i bhfostú

Má tá tú i bhfostú, is gnách go bhfaighidh tú duine éigin sásta cabhrú sa chainéal _#omarchy-help_ ar [Discord an phobail](https://omarchy.org/discord).
