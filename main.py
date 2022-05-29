import sys
import moderngl_window as mglw

# Using the latest shaders version of OpenGL available on MacOS
# which is 410 core
class App(mglw.WindowConfig):
    # TODO: Set your desired screen size here
    window_size = 3072/4, 1920/4
    # resource_dir = 'shaders/mandelbort/'
    resource_dir = 'shaders/cardioid/'

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.quad = mglw.geometry.quad_fs()

        self.prog = self.load_program(vertex_shader='vertex_shader.glsl',
                                      fragment_shader='fragment_shader.glsl')
        self.set_uniform('resolution', self.window_size)

    def set_uniform(self, u_name, u_value):
        try:
            self.prog[u_name] = u_value
        except:
            print(f'uniform: {u_name} - not used in shader')

    def render(self, time, frame_time):
        self.ctx.clear()
        self.set_uniform('time', time)
        # self.set_uniform('frame_time', frame_time)
        self.quad.render(self.prog)


def main():
    args = sys.argv[1:]
    print(args)
    mglw.run_window_config(App)

main()