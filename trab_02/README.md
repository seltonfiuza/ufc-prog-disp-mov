# trab_02 - 5 contatos

## 

O video é o arquivo

> video.mp4

No video não mostra, mas caso o usuario nao dê permissão, é inciado o app telefone com o numero preenchido



    makeCall(phone) async {
        if (await Permission.phone.request().isGranted) {
            await FlutterPhoneDirectCaller.callNumber(phone);
        } else {
            launch('tel://${phone}');
        }
    }


### Adicionais
Eu implementei cadastro de vários usuarios como adicional no video mostra eu saindo de um, entrando em outro e o usuario do primeiro persistindo.