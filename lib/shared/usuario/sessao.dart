import 'package:shared_preferences/shared_preferences.dart';
import 'package:pex/repositorios/medicos_repositorio.dart';
import 'perfil_usuario.dart';

const _chaveMedicoSalvo = 'medico_logado_id';

PerfilUsuario? _medicoLogado;

PerfilUsuario? get medicoLogado => _medicoLogado;

int get medicoLogadoId {
  final medico = _medicoLogado;
  if (medico == null) {
    throw StateError('Nenhum médico entrou no aplicativo.');
  }
  return medico.id;
}

void iniciarSessao(PerfilUsuario medico) {
  _medicoLogado = medico;
}

void encerrarSessao() {
  _medicoLogado = null;
}

Future<void> entrarESalvarSessao(PerfilUsuario medico) async {
  iniciarSessao(medico);
  final preferencias = await SharedPreferences.getInstance();
  await preferencias.setInt(_chaveMedicoSalvo, medico.id);
}

Future<void> sairDaSessao() async {
  encerrarSessao();
  final preferencias = await SharedPreferences.getInstance();
  await preferencias.remove(_chaveMedicoSalvo);
}

Future<void> restaurarSessao() async {
  try {
    final preferencias = await SharedPreferences.getInstance();
    final id = preferencias.getInt(_chaveMedicoSalvo);
    if (id == null) return;

    final medico = await buscarMedico(id);
    if (medico == null) {
      await preferencias.remove(_chaveMedicoSalvo);
      return;
    }
    iniciarSessao(medico);
  } catch (_) {
    encerrarSessao();
  }
}
