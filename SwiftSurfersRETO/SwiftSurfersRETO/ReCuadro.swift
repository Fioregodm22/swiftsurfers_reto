import SwiftUI

struct ReCuadro: View {
    let servicio: Servicio
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                
                // Hora + icono
                HStack {
                    Image(servicio.status.Image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                    
                    // Muestra solo la hora, p.ej. "2:30 PM"
                    Text(servicio.hora, style: .time)
                        .font(.system(size: 26))
                    
                    Spacer()
                    
                    // Badge de estado con color dinámico
                    Text(servicio.status.nombre)
                        .font(.caption).bold()
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(servicio.status.color.opacity(0.15))
                        .foregroundStyle(servicio.status.color)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
    
                Spacer()
                
                // Paciente
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.gray)
                    Text(servicio.paciente)
                        .font(.system(size: 20))
                    Spacer()
                }
                
                Spacer()
                
                // Origen
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Origen")
                            .font(.system(size: 20)).bold()
                        Text(servicio.origen)
                            .font(.system(size: 18))
                    }
                    Spacer()
                }
                
                Spacer()
                
                // Destino
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Destino")
                            .font(.system(size: 20)).bold()
                        Text(servicio.destino)
                            .font(.system(size: 18))
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.08))
        .frame(width: 340, height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
}

#Preview {
    ReCuadro(servicio: .ejemplo)
}
